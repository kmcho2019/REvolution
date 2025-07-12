module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] state; // count of consecutive ones, saturate at 7

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'd0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            // compute next state
            if (in) begin
                if (state < 3'd7)
                    state <= state + 3'd1;
                else
                    state <= 3'd7; // saturate
            end else begin
                state <= 3'd0;
            end

            // outputs delayed by one cycle, based on previous state and current input
            disc <= (state == 3'd5) && (in == 1'b0);
            flag <= (state == 3'd6) && (in == 1'b0);
            err  <= (state == 3'd7) && (in == 1'b1);
        end
    end

endmodule