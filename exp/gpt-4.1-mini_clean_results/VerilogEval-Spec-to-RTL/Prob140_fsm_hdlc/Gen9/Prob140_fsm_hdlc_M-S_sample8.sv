module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] state, next_state;

    // Next state logic: count consecutive ones up to 7, else 0 on zero input
    always @(*) begin
        if (in) begin
            if (state < 7)
                next_state = state + 1;
            else
                next_state = 7;
        end else begin
            next_state = 0;
        end
    end

    wire disc_w = (state == 5) && (in == 1'b0);
    wire flag_w = (state == 6) && (in == 1'b0);
    wire err_w  = (next_state == 7);

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            disc  <= disc_w;
            flag  <= flag_w;
            err   <= err_w;
        end
    end

endmodule