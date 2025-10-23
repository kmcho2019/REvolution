module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

// Reg to store intermediate sum values
reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

// Initialize reg1 and reg2
initial begin
    reg1 = 0;
    reg2 = 0;
end

// Perform multiplication and addition
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 0;
        reg2 <= 0;
        mul_out <= 0;
    end else begin
        // Initialize reg1 with the partial product for the least significant bit of the multiplier
        reg1 <= (mul_b[0] == 1'b1)? {size{1'b0}} + mul_a : {size{1'b0}};
        
        // Perform addition for each bit position of the multiplier
        for (int i = 1; i < size; i++) begin
            reg2 <= reg1 + ((mul_b[i] == 1'b1)? {size{1'b0}} + (mul_a << i) : {size{1'b0}});
        end
        
        // Update the final product output
        mul_out <= reg2;
    end
end

endmodule