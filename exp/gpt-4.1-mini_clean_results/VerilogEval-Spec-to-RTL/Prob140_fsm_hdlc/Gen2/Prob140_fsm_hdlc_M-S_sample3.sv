module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

reg [3:0] state, prev_state; 
// state encodes count of consecutive ones (0-6), 7 = error

localparam ERROR = 4'd7;

always @(posedge clk) begin
    if (reset) begin
        state <= 4'd0;
        prev_state <= 4'd0;
        disc <= 1'b0;
        flag <= 1'b0;
        err  <= 1'b0;
    end else begin
        prev_state <= state;

        // Update state count of consecutive ones or error
        if (in) begin
            if (state < ERROR)
                state <= state + 1;
        end else begin
            state <= 4'd0;
        end

        // Outputs asserted one cycle after detection:
        // disc: prev_state==5 && current state==0 (zero after 5 ones)
        disc <= (prev_state == 4'd5 && state == 4'd0) ? 1'b1 : 1'b0;

        // flag: prev_state==6 && current state==0 (zero after 6 ones)
        flag <= (prev_state == 4'd6 && state == 4'd0) ? 1'b1 : 1'b0;

        // err: state == 7 (7 or more ones)
        err <= (state == ERROR) ? 1'b1 : 1'b0;
    end
end

endmodule