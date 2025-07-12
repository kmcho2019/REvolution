module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // Define states with proper 4-bit encoding
    localparam STATE_0    = 4'd0;
    localparam STATE_1    = 4'd1;
    localparam STATE_2    = 4'd2;
    localparam STATE_3    = 4'd3;
    localparam STATE_4    = 4'd4;
    localparam STATE_5    = 4'd5;
    localparam STATE_DISC = 4'd6;
    localparam STATE_FLAG = 4'd7;
    localparam STATE_ERR  = 4'd8;

    reg [3:0] current_state;

    // State transition logic (sequential)
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_0;
        end else begin
            case (current_state)
                STATE_0:    current_state <= in ? STATE_1 : STATE_0;
                STATE_1:    current_state <= in ? STATE_2 : STATE_0;
                STATE_2:    current_state <= in ? STATE_3 : STATE_0;
                STATE_3:    current_state <= in ? STATE_4 : STATE_0;
                STATE_4:    current_state <= in ? STATE_5 : STATE_0;
                STATE_5:    current_state <= in ? STATE_FLAG : STATE_DISC;
                STATE_FLAG: current_state <= in ? STATE_ERR : STATE_0;
                STATE_DISC: current_state <= in ? STATE_1 : STATE_0;
                STATE_ERR:  current_state <= in ? STATE_ERR : STATE_0;
                default:    current_state <= STATE_0;
            endcase
        end
    end

    // Output generation (combinational)
    assign disc = (current_state == STATE_DISC);
    assign flag = (current_state == STATE_FLAG);
    assign err  = (current_state == STATE_ERR);

endmodule