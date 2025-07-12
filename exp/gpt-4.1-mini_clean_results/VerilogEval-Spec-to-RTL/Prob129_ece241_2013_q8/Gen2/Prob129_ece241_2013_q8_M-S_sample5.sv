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

    reg [1:0] state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
            z <= 1'b0;
        end else begin
            z <= 1'b0;
            case (state)
                IDLE: begin
                    if (x)
                        state <= ONE;
                    else
                        state <= IDLE;
                end

                ONE: begin
                    if (x)
                        state <= ONE;
                    else
                        state <= TEN;
                end

                TEN: begin
                    if (x) begin
                        state <= ONE;
                        z <= 1'b1; // "101" detected
                    end else
                        state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule