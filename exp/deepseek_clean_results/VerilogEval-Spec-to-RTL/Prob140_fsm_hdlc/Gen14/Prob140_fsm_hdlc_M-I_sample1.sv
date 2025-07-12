module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot encoded states for 0-6 consecutive 1s
    reg [6:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 7'b0000001;  // Reset to state 0 (only lsb set)
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Update state only when input is 1
            if (in) begin
                case (state)
                    7'b0000001: state <= 7'b0000010; // 0->1
                    7'b0000010: state <= 7'b0000100; // 1->2
                    7'b0000100: state <= 7'b0001000; // 2->3
                    7'b0001000: state <= 7'b0010000; // 3->4
                    7'b0010000: state <= 7'b0100000; // 4->5
                    7'b0100000: state <= 7'b1000000; // 5->6
                    default:    state <= 7'b1000000; // 6+ stays at 6
                endcase
            end else begin
                state <= 7'b0000001; // Reset to state 0 on 0 input
            end

            // Set outputs for next cycle
            disc <= (state == 7'b0100000) && !in; // 5 consecutive 1s followed by 0
            flag <= (state == 7'b1000000) && !in; // 6 consecutive 1s followed by 0
            err <= (state == 7'b1000000) && in;   // 6+ consecutive 1s
        end
    end

endmodule