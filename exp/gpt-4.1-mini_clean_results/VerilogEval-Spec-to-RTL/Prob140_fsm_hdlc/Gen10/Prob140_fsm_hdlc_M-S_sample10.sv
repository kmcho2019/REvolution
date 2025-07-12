module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'd0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            // Compute next state: count consecutive ones saturating at 7
            if (in) begin
                if (state < 3'd7)
                    state <= state + 3'd1;
                else
                    state <= 3'd7;
            end else begin
                state <= 3'd0;
            end

            // Registered outputs assert one cycle after detecting conditions:
            disc <= (state == 3'd5) && (in == 1'b0);
            flag <= (state == 3'd6) && (in == 1'b0);
            err  <= (in && (state == 3'd7));
        end
    end

endmodule