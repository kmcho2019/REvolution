module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // Define states
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Shift register for last 3 w values
    reg [2:0] w_history;
    // Flag indicating we have 3 samples
    wire ready = &w_history[1:0]; // True when bits [1:0] are both 1

    // Combinational output
    assign z = (state == B) && ready && ((w_history[0] + w_history[1] + w) == 2);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_history <= 3'b000;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        w_history <= 3'b001; // Initialize with [0]=1 to start counting
                    end
                end
                B: begin
                    // Shift in new w and update tracking bits
                    w_history <= {w_history[1:0], w};
                end
            endcase
        end
    end

endmodule