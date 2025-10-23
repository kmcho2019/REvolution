module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

reg [2:0] state;
parameter IDLE = 3'b000, START_BIT = 3'b001, DATA_BITS = 3'b010, STOP_BIT = 3'b011, INVALID = 3'b100;
reg [7:0] data;
reg [3:0] counter;
reg valid;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        valid <= 1'b0;
        data <= 8'b0;
        counter <= 4'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (~in) begin
                    state <= START_BIT;
                    counter <= 4'b1;
                end
            end
            START_BIT: begin
                data[0] <= in;
                counter <= counter + 1'b1;
                if (counter == 4'd8) begin
                    state <= STOP_BIT;
                    valid <= 1'b1;
                end
                else begin
                    state <= DATA_BITS;
                end
            end
            DATA_BITS: begin
                data[counter - 2] <= in;
                counter <= counter + 1'b1;
                if (counter == 4'd8) begin
                    state <= STOP_BIT;
                end
            end
            STOP_BIT: begin
                if (in) begin
                    state <= IDLE;
                    done <= valid;
                    valid <= 1'b0;
                end
                else begin
                    state <= INVALID;
                end
            end
            INVALID: begin
                if (in) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule