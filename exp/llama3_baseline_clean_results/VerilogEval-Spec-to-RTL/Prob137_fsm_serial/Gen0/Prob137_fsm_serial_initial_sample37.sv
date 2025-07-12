module TopModule (
    input  clk,
    input  reset,
    input  in,
    output done
);

reg [2:0] state;
reg [3:0] data_count;
reg [7:0] byte;

parameter IDLE = 3'b001;
parameter START = 3'b010;
parameter DATA = 3'b011;
parameter STOP = 3'b100;
parameter ERROR = 3'b101;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_count <= 4'b0000;
        byte <= 8'b00000000;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (!in) begin
                    state <= START;
                end
            end
            START: begin
                state <= DATA;
            end
            DATA: begin
                byte[7 - data_count] <= in;
                data_count <= data_count + 1'b1;
                if (data_count == 4'b1000) begin
                    state <= STOP;
                end
            end
            STOP: begin
                if (in) begin
                    done <= 1'b1;
                    state <= IDLE;
                    data_count <= 4'b0000;
                    byte <= 8'b00000000;
                end else begin
                    state <= ERROR;
                end
            end
            ERROR: begin
                if (in) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule