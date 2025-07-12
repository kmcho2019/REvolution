module JC_counter (
    input  wire       clk,    // Clock signal for synchronous operation
    input  wire       rst_n,  // Asynchronous active-low reset
    output reg [63:0] Q       // 64-bit Johnson counter output
);

    reg feedback_reg;  // Registered feedback bit (pipelined)

    // On reset or clock edge, update Q and feedback_reg
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Q <= 64'b0;
            feedback_reg <= 1'b1; // Initialize feedback_reg to 1, so next cycle is correct
        end else begin
            feedback_reg <= ~Q[0];       // Register feedback bit (inverted LSB)
            Q <= {feedback_reg, Q[63:1]}; // Shift right with registered feedback at MSB
        end
    end

endmodule