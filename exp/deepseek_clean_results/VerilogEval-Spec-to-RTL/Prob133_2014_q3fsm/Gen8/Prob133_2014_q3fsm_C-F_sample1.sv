module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Window tracking
    reg [1:0] cycle_count;  // Modulo-3 counter (0-2)
    reg [2:0] w_history;    // Stores last 3 w values
    reg evaluation_flag;    // Indicates evaluation cycle

    // Count number of 1's in w_history
    wire [1:0] ones_count = w_history[0] + w_history[1] + w_history[2];

    // Output logic - active when in state B and evaluation flag is set
    assign z = (state == B) && evaluation_flag && (ones_count == 2'd2);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'b00;
            w_history <= 3'b000;
            evaluation_flag <= 1'b0;
        end else begin
            evaluation_flag <= 1'b0;  // Default clear

            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        cycle_count <= 2'b00;
                        w_history <= 3'b000;
                    end
                end

                B: begin
                    // Shift in new w value
                    w_history <= {w_history[1:0], w};

                    // Update modulo-3 counter
                    if (cycle_count == 2'd2) begin
                        cycle_count <= 2'd0;
                        evaluation_flag <= 1'b1;  // Set flag at window end
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end
                end
            endcase
        end
    end

endmodule