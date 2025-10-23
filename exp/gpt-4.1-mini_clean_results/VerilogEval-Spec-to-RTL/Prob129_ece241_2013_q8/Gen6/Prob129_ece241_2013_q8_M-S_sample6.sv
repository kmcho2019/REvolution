module TopModule (
    input  wire clk,
    input  wire aresetn,
    input  wire x,
    output reg  z
);

    localparam [1:0]
        IDLE = 2'b00,
        ONE  = 2'b01,
        TEN  = 2'b10;

    reg [1:0] state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
            z <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (x) begin
                        state <= ONE;
                        z <= 1'b0;
                    end else begin
                        state <= IDLE;
                        z <= 1'b0;
                    end
                end

                ONE: begin
                    if (x) begin
                        state <= ONE;
                        z <= 1'b0;
                    end else begin
                        state <= TEN;
                        z <= 1'b0;
                    end
                end

                TEN: begin
                    if (x) begin
                        state <= ONE;
                        z <= 1'b1; // "101" detected on input x=1 in TEN state
                    end else begin
                        state <= IDLE;
                        z <= 1'b0;
                    end
                end

                default: begin
                    state <= IDLE;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule