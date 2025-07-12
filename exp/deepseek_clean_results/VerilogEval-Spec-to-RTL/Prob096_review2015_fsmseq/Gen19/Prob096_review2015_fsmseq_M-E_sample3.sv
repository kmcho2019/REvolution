module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // One-hot encoded states
    reg [3:0] state;
    parameter IDLE     = 4'b0001;
    parameter GOT_1    = 4'b0010;
    parameter GOT_11   = 4'b0100;
    parameter GOT_110  = 4'b1000;

    reg found;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            found <= 1'b0;
        end else if (!found) begin
            case (state)
                IDLE:   state <= (data) ? GOT_1 : IDLE;
                GOT_1:  state <= (data) ? GOT_11 : IDLE;
                GOT_11: state <= (data) ? GOT_11 : GOT_110;
                GOT_110: begin
                    found <= data;
                    state <= (data) ? GOT_1 : IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

    assign start_shifting = found;

endmodule