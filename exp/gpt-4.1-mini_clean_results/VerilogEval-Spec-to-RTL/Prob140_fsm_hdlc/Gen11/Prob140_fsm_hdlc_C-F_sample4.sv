module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // 3-bit counter state: counts consecutive ones up to 7 (saturate)
    reg [2:0] state, next_state;

    // Next state logic: increment on 'in'==1 up to 7; reset to 0 on zero input
    always @(*) begin
        if (in) begin
            if (state < 3'd7)
                next_state = state + 3'd1;
            else
                next_state = 3'd7;
        end else begin
            next_state = 3'd0;
        end
    end

    // Output conditions depend on previous state and current input
    wire disc_w = (state == 3'd5) && (in == 1'b0);
    wire flag_w = (state == 3'd6) && (in == 1'b0);
    wire err_w  = (next_state == 3'd7);

    // Sequential logic to update state and outputs synchronously
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'd0;
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