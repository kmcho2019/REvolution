module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot encoded states for better timing
    localparam STATE_0    = 4'b0001;
    localparam STATE_1    = 4'b0010;
    localparam STATE_2    = 4'b0100;
    localparam STATE_3    = 4'b1000;
    localparam STATE_4    = 4'b0001; // Reuse encoding
    localparam STATE_5    = 4'b0010; // Reuse encoding
    localparam STATE_DISC = 4'b0100; // Reuse encoding
    localparam STATE_FLAG = 4'b1000; // Reuse encoding
    localparam STATE_ERR  = 4'b0001; // Reuse encoding

    reg [3:0] current_state, next_state;

    // State transition logic
    always @(*) begin
        next_state = STATE_0; // Default to initial state
        case (current_state)
            STATE_0:    next_state = in ? STATE_1 : STATE_0;
            STATE_1:    next_state = in ? STATE_2 : STATE_0;
            STATE_2:    next_state = in ? STATE_3 : STATE_0;
            STATE_3:    next_state = in ? STATE_4 : STATE_0;
            STATE_4:    next_state = in ? STATE_5 : STATE_0;
            STATE_5:    next_state = in ? STATE_FLAG : STATE_DISC;
            STATE_FLAG: next_state = in ? STATE_ERR : STATE_0;
            STATE_DISC: next_state = STATE_0;
            STATE_ERR:  next_state = in ? STATE_ERR : STATE_0;
            default:    next_state = STATE_0;
        endcase
    end

    // Output generation (pure Moore machine)
    always @(*) begin
        disc = (current_state == STATE_DISC);
        flag = (current_state == STATE_FLAG) && !in;
        err  = (current_state == STATE_ERR);
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_0;
        end else begin
            current_state <= next_state;
        end
    end

endmodule