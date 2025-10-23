module TopModule (
    input clk,
    input x,
    output reg z
);

    reg [1:0] state;       // Modulo-3 counter (0,1,2)
    reg [2:0] stored_vals; // Stores XOR, AND, OR results
    reg current_val;       // Temporary storage for current operation
    
    // State transition
    always @(posedge clk) begin
        state <= (state == 2'd2) ? 2'd0 : state + 1;
    end

    // Operation selection and computation
    always @(posedge clk) begin
        case(state)
            2'd0: current_val <= x ^ stored_vals[0];  // XOR operation
            2'd1: current_val <= x & ~stored_vals[1];  // AND operation
            2'd2: current_val <= x | ~stored_vals[2];  // OR operation
        endcase
    end

    // Store results in shift register
    always @(posedge clk) begin
        stored_vals <= {current_val, stored_vals[2:1]};
    end

    // Output logic - NOR of all stored values
    always @(*) begin
        z = ~(|stored_vals);
    end

    // Initialization
    initial begin
        state = 2'd0;
        stored_vals = 3'b0;
        current_val = 1'b0;
    end

endmodule