module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

reg [7:0] data_reg;
reg [3:0] count;
reg [1:0] state;

localparam IDLE = 2'b00;
localparam START = 2'b01;
localparam DATA = 2'b10;
localparam STOP = 2'b11;

always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        count <= 0;
        data_reg <= 8'b0;
        done <= 1'b0;
    end else begin
        case(state)
            IDLE: begin
                if(!in) begin
                    state <= START;
                end
            end
            START: begin
                if(in == 1'b0) begin
                    state <= DATA;
                    data_reg <= 8'b0;
                    count <= 0;
                end else if(in == 1'b1) begin
                    state <= IDLE;
                end
            end
            DATA: begin
                data_reg <= {data_reg[6:0], in};
                count <= count + 1;
                if(count == 8) begin
                    state <= STOP;
                end
            end
            STOP: begin
                if(in == 1'b1) begin
                    done <= 1'b1;
                    state <= IDLE;
                end else begin
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

always @(negedge clk) begin
    done <= 1'b0;
end

endmodule