module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [4:0] ctr;
reg [15:0] product;
reg [15:0] partial_product;
reg [1:0] state;

// Define the states
localparam IDLE = 2'b00;
localparam RUN = 2'b01;
localparam DONE = 2'b10;

// Stage 1: Initialization
always @(posedge clk) begin
    if (reset) begin
        multiplicand <= 0;
        multiplier <= 0;
        product <= 0;
        ctr <= 0;
        rdy <= 0;
    end else if (state == IDLE) begin
        multiplicand <= {{8{b[7]}}, b};
        multiplier <= {{8{a[7]}}, a};
        state <= RUN;
    end
end

// Stage 2: Booth Encoding and Partial Product Generation
always @(posedge clk) begin
    if (state == RUN) begin
        if (ctr < 16) begin
            if (multiplier[ctr] == 1) begin
                partial_product <= multiplicand;
            end else begin
                partial_product <= 0;
            end
            ctr <= ctr + 1;
        end else begin
            state <= DONE;
        end
    end
end

// Stage 3: Product Accumulation
always @(posedge clk) begin
    if (state == RUN) begin
        product <= product + partial_product;
    end
end

// Stage 4: Output
always @(posedge clk) begin
    if (state == DONE) begin
        p <= product;
        rdy <= 1;
        state <= IDLE;
    end
end

endmodule