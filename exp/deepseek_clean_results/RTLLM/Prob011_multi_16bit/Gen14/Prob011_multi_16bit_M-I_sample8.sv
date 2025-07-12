module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output done
);

// State encoding (one-hot)
localparam IDLE = 1'b0;
localparam RUN  = 1'b1;

reg state;
reg [4:0] bit_pos;  // 5-bit to cover 0-16
reg [15:0] areg;
reg [15:0] breg;
reg [31:0] product;
reg product_en;     // Clock gating control

// Barrel shifter for on-demand shifting
wire [31:0] shifted_b = breg << bit_pos;

// State machine and calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        bit_pos <= 5'b0;
        areg <= 16'b0;
        breg <= 16'b0;
        product <= 32'b0;
        product_en <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= RUN;
                    areg <= ain;
                    breg <= bin;
                    product <= 32'b0;
                    bit_pos <= 5'b0;
                    product_en <= 1'b1;
                end
                else begin
                    product_en <= 1'b0;
                end
            end
            
            RUN: begin
                if (bit_pos < 16) begin
                    // Conditional accumulation
                    if (areg[bit_pos]) begin
                        product <= product + shifted_b;
                    end
                    bit_pos <= bit_pos + 1;
                end
                else begin
                    state <= IDLE;
                    product_en <= 1'b0;
                end
            end
        endcase
    end
end

// Clock gating implementation
always @(posedge clk) begin
    if (product_en) begin
        yout <= product;
    end
end

// Output assignments
assign done = (state == IDLE) && (bit_pos == 16);

endmodule