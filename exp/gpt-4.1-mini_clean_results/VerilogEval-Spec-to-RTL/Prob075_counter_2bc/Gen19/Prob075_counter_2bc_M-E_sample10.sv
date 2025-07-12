module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    // Next state logic: explicitly saturate increment/decrement without arithmetic operators
    wire [1:0] next_state;
    reg [1:0] temp_state;

    always @(*) begin
        if (train_valid) begin
            if (train_taken) begin
                // Increment saturating at 3
                case (state)
                    2'd0: temp_state = 2'd1;
                    2'd1: temp_state = 2'd2;
                    2'd2: temp_state = 2'd3;
                    2'd3: temp_state = 2'd3;
                    default: temp_state = 2'd1; // fallback to weakly not-taken
                endcase
            end else begin
                // Decrement saturating at 0
                case (state)
                    2'd0: temp_state = 2'd0;
                    2'd1: temp_state = 2'd0;
                    2'd2: temp_state = 2'd1;
                    2'd3: temp_state = 2'd2;
                    default: temp_state = 2'd1;
                endcase
            end
        end else begin
            temp_state = state; // hold state if train_valid not asserted
        end
    end

    assign next_state = temp_state;

    // State register with asynchronous positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // weakly not-taken reset state
        else
            state <= next_state;
    end

endmodule