module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    // One-hot encoded states: 0001(0), 0011(1), 0111(2), 1111(3)
    reg [3:0] shift_state;

    // Next state logic
    wire [3:0] next_state;
    assign next_state = areset ? 4'b0011 :               // Reset to weakly not-taken (state 1)
                      ~train_valid ? shift_state :      // Hold when not training
                      train_taken ? 
                          (shift_state[3] ? shift_state : {shift_state[2:0], 1'b1}) : // Right shift for increment
                          (shift_state[0] ? shift_state : {1'b0, shift_state[3:1]});  // Left shift for decrement

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            shift_state <= 4'b0011;  // Reset to state 1 (01 in binary)
        end else begin
            shift_state <= next_state;
        end
    end

    // Convert one-hot to binary
    assign state = (shift_state == 4'b0001) ? 2'b00 :
                  (shift_state == 4'b0011) ? 2'b01 :
                  (shift_state == 4'b0111) ? 2'b10 :
                  2'b11;

endmodule