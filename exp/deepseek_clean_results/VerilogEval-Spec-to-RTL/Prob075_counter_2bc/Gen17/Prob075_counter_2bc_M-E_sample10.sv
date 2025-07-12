module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    reg [1:0] counter;

    // Shift-based next state logic
    wire shift_right = train_valid & train_taken & ~(&counter);  // Increment if not max
    wire shift_left = train_valid & ~train_taken & |counter;     // Decrement if not min

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter <= 2'b01;  // Reset to weakly not-taken
        end else begin
            case ({shift_right, shift_left})
                2'b10: counter <= {counter[0], 1'b1};    // Right shift (increment)
                2'b01: counter <= {1'b0, counter[1]};    // Left shift (decrement)
                default: counter <= counter;             // Hold value
            endcase
        end
    end

    assign state = counter;

endmodule