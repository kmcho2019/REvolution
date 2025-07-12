module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Registers to store intermediate values
reg [2*size-1:0] reg_a;
reg [2*size-1:0] reg_b;
reg [2*size-1:0] reg_sum;
reg [2*size-1:0] reg_product;

// State machine (simplified)
reg [1:0] state;
reg [size-1:0] count;

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00;
        count <= {size{1'b0}};
        reg_a <= {2*size{1'b0}};
        reg_b <= {2*size{1'b0}};
        reg_sum <= {2*size{1'b0}};
        reg_product <= {2*size{1'b0}};
    end else begin
        case (state)
            2'b00: begin // Initialization
                reg_a <= {size{1'b0}} | mul_a;
                reg_b <= {size{1'b0}} | mul_b;
                reg_sum <= {2*size{1'b0}};
                state <= 2'b01;
                count <= 1'b1;
            end
            2'b01: begin // Multiplication and sum
                if (count < size) begin
                    if (reg_b[count-1] == 1'b1) begin
                        reg_sum <= reg_sum + (reg_a << (count-1));
                    end
                    count <= count + 1'b1;
                end else begin
                    state <= 2'b10;
                end
            end
            2'b10: begin // Final product
                reg_product <= reg_sum;
                state <= 2'b11;
            end
            2'b11: begin // Output
                mul_out <= reg_product;
            end
        endcase
    end
end

endmodule