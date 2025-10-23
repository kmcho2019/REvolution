module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    reg [1:0] state;
    reg [2:0] counter;
    reg [7:0] data_shift;

    // State transition and data handling
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counter <= 3'b0;
            data_shift <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (~in) begin
                        state <= RECEIVE;
                        counter <= 3'b0;
                    end
                end

                RECEIVE: begin
                    data_shift <= {in, data_shift[7:1]};
                    if (counter == 3'b111)
                        state <= STOP;
                    else
                        counter <= counter + 1;
                end

                STOP: begin
                    if (in)
                        state <= IDLE;
                end
            endcase
        end
    end

    // Done signal is high when we're in STOP state and in=1
    assign done = (state == STOP) & in;

endmodule