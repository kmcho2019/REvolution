module parallel_radix4_booth_multiplier(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// Parameters
parameter NUM_SEGMENTS = 4;
parameter SEGMENT_SIZE = 2;

// Internal signals
reg [15:0] partial_products [NUM_SEGMENTS-1:0];
reg [15:0] product;
reg [NUM_SEGMENTS-1:0] valid_segments;
reg [NUM_SEGMENTS-1:0] segment_enable;
reg [4:0] counter;
reg start_multiplier;

// Control unit
always @(posedge clk) begin
    if (reset) begin
        start_multiplier <= 0;
        counter <= 0;
        rdy <= 0;
    end else if (start_multiplier) begin
        // Start multiplication process
        if (counter < NUM_SEGMENTS) begin
            // Enable segments based on input data
            valid_segments[counter] <= (a[counter*SEGMENT_SIZE +: SEGMENT_SIZE] != 0) || (b[counter*SEGMENT_SIZE +: SEGMENT_SIZE] != 0);
            counter <= counter + 1;
        end else begin
            // All segments processed, assert ready signal
            rdy <= 1;
            start_multiplier <= 0;
        end
    end else begin
        // Initialize for new multiplication
        if (a != 0 || b != 0) begin
            start_multiplier <= 1;
        end
    end
end

// Parallel multipliers
genvar i;
generate
    for (i = 0; i < NUM_SEGMENTS; i++) begin: multiplier_gen
        radix4_booth_multiplier u_radix4_booth_multiplier(
            .clk(clk),
            .reset(reset),
            .a(a[i*SEGMENT_SIZE +: SEGMENT_SIZE]),
            .b(b[i*SEGMENT_SIZE +: SEGMENT_SIZE]),
            .product(partial_products[i]),
            .enable(segment_enable[i])
        );
    end
endgenerate

// Pipelined accumulator
always @(posedge clk) begin
    if (reset) begin
        product <= 0;
    end else if (start_multiplier) begin
        // Accumulate partial products
        for (int i = 0; i < NUM_SEGMENTS; i++) begin
            if (valid_segments[i]) begin
                product <= product + partial_products[i];
            end
        end
    end
end

// Dynamic clock gating
always @(posedge clk) begin
    if (reset) begin
        segment_enable <= 0;
    end else if (start_multiplier) begin
        // Enable segments based on validity
        for (int i = 0; i < NUM_SEGMENTS; i++) begin
            segment_enable[i] <= valid_segments[i];
        end
    end
end

// Output product
always @(posedge clk) begin
    if (reset) begin
        p <= 0;
    end else if (rdy) begin
        p <= product;
    end
end

endmodule

// Radix-4 Booth multiplier module (for each segment)
module radix4_booth_multiplier(
    input clk,
    input reset,
    input [1:0] a,
    input [1:0] b,
    output reg [3:0] product,
    input enable
);

reg [1:0] multiplicand;
reg [1:0] multiplier;
reg [1:0] partial_product;

always @(posedge clk) begin
    if (reset) begin
        product <= 0;
    end else if (enable) begin
        // Radix-4 Booth multiplication
        case (a)
            2'b00: begin
                partial_product <= 0;
            end
            2'b01: begin
                partial_product <= b;
            end
            2'b10: begin
                partial_product <= -b;
            end
            2'b11: begin
                partial_product <= -2*b;
            end
        endcase
        product <= product + partial_product;
    end
end

endmodule