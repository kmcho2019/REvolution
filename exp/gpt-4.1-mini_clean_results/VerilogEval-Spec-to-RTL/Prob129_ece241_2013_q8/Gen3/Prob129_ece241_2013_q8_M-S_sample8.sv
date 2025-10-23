module TopModule(
    input  wire clk,
    input  wire aresetn,
    input  wire x,
    output reg  z
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam ONE  = 2'b01;
    localparam TEN  = 2'b10;

    reg [1:0] state, next_state;

    always @(*) begin
        case (state)
            IDLE: begin
                next_state = x ? ONE : IDLE;
                z = 1'b0;
            end
            ONE: begin
                next_state = x ? ONE : TEN;
                z = 1'b0;
            end
            TEN: begin
                if (x) begin
                    next_state = ONE;
                    z = 1'b1; // "101" detected
                end else begin
                    next_state = IDLE;
                    z = 1'b0;
                end
            end
            default: begin
                next_state = IDLE;
                z = 1'b0;
            end
        endcase
    end

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= IDLE;
        else
            state <= next_state;
    end

endmodule