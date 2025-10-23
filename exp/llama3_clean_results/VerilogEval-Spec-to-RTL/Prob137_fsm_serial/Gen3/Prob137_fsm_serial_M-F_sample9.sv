module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// Define states
enum logic [1:0] {IDLE, DATA, STOP} state;

// Data register
reg [7:0] data;
reg [2:0] dataCnt;

always_ff @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= IDLE;
        done <= 1'b0;
        data <= 8'b0;
        dataCnt <= 3'b0;
    end else begin
        case(state)
            IDLE: begin
                if(in == 1'b0) begin
                    state <= DATA;
                    data[0] <= in;
                    dataCnt <= 3'b1;
                end
            end
            DATA: begin
                if(dataCnt < 3'b1000) begin
                    data <= {data[6:0], in};
                    dataCnt <= dataCnt + 3'b1;
                end else begin
                    state <= STOP;
                end
            end
            STOP: begin
                if(in == 1'b1) begin
                    done <= 1'b1;
                    state <= IDLE;
                end else begin
                    state <= STOP;
                end
            end
        endcase
        if(state == IDLE) begin
            done <= 1'b0;
        end
    end
end

endmodule