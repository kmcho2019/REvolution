module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] state;
    reg [2:0] next_state;

    // Compute next state combinationally:
    // increment state on input=1 (saturate at 7), reset to 0 on input=0
    always @(*) begin
        if (in)
            next_state = (state < 3'd7) ? (state + 3'd1) : 3'd7;
        else
            next_state = 3'd0;
    end

    // Moore output conditions based on current state and input
    wire disc_w = (state == 3'd5) && (in == 1'b0);  // 0111110 pattern detected
    wire flag_w = (state == 3'd6) && (in == 1'b0);  // 01111110 pattern detected
    wire err_w  = (next_state == 3'd7) && (in == 1'b1); // 7+ consecutive ones error

    // Sequential logic: register state and outputs with synchronous reset
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