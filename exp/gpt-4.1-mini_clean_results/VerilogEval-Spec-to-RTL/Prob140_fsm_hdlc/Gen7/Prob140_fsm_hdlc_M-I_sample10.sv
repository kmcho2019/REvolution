module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] state, next_state;

    // Next state logic: count consecutive ones, saturate at 7
    always @(*) begin
        if (in) begin
            if (state < 3'd7)
                next_state = state + 3'd1;
            else
                next_state = 3'd7; // saturate at error state
        end else begin
            next_state = 3'd0; // reset count on zero input
        end
    end

    // Outputs combinational logic:
    // disc: exactly 5 consecutive ones, then zero => state==5 and in=0
    // flag: exactly 6 consecutive ones, then zero => state==6 and in=0
    // err: 7 or more consecutive ones detected immediately => next_state==7
    wire disc_w = (state == 3'd5) && (in == 1'b0);
    wire flag_w = (state == 3'd6) && (in == 1'b0);
    wire err_w  = (next_state == 3'd7);

    // Sequential logic: state update and registered outputs
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