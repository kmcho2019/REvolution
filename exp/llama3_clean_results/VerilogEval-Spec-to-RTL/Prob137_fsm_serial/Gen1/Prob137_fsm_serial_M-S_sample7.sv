module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// Define states
enum logic [1:0] {IDLE, DATA, STOP} state, nextState;

// Data register
reg [7:0] data;
reg [3:0] dataCnt;

always_ff @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= IDLE;
        done <= 1'b0;
        data <= 8'b0;
        dataCnt <= 4'b0;
    end else begin
        state <= nextState;
        case(state)
            IDLE: begin
                if(in == 1'b0) begin
                    nextState <= DATA;
                    dataCnt <= 4'b1;
                    data[0] <= in;
                end else begin
                    nextState <= IDLE;
                end
            end
            DATA: begin
                if(dataCnt < 4'b1000) begin
                    data[dataCnt] <= in;
                    dataCnt <= dataCnt + 4'b1;
                    nextState <= DATA;
                end else begin
                    nextState <= STOP;
                end
            end
            STOP: begin
                if(in == 1'b1) begin
                    done <= 1'b1;
                    nextState <= IDLE;
                end else begin
                    done <= 1'b0;
                    nextState <= STOP;
                end
            end
        endcase
    end
end

always_comb begin
    if(state == STOP) begin
        done = in == 1'b1? 1'b1 : 1'b0;
    end else begin
        done = 1'b0;
    end
end

endmodule