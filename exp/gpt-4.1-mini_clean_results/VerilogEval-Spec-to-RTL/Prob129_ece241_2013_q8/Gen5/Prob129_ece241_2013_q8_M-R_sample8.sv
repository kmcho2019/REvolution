module TopModule(
    input  wire clk,
    input  wire aresetn,
    input  wire x,
    output wire z
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam ONE  = 2'b01;
    localparam TEN  = 2'b10;

    reg [1:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: next_state = x ? ONE : IDLE;
            ONE:  next_state = x ? ONE : TEN;
            TEN:  next_state = x ? ONE : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic (combinational assign)
    assign z = (state == TEN) && x;

    // State register with async negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= IDLE;
        else
            state <= next_state;
    end

endmodule