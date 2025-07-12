module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] state;      // current count of consecutive ones (0 to 7)
    reg [2:0] next_state; // combinational next state

    // Combinational logic for next state
    // If input is 1, increment saturating at 7; else reset to 0
    always @(*) begin
        if (in)
            next_state = (state < 3'd7) ? (state + 3'd1) : 3'd7;
        else
            next_state = 3'd0;
    end

    // Combinational outputs based on current state and input
    // Moore outputs asserted for exactly one cycle starting next clock
    wire disc_w = (state == 3'd5) && (in == 1'b0); // after exactly 5 ones then zero
    wire flag_w = (state == 3'd6) && (in == 1'b0); // after exactly 6 ones then zero
    wire err_w  = (next_state == 3'd7) && in;      // error on saturating at 7+ ones input

    // Sequential logic: state register and output registers update on clk
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