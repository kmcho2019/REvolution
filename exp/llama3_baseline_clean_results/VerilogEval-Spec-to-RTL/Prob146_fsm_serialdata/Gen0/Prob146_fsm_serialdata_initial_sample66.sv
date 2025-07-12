module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg;
reg [2:0] state_next;
reg [2:0] counter_reg;
reg [2:0] counter_next;
reg [7:0] data_reg;
reg [7:0] data_next;

always @(*) begin
    case(state_reg)
        3'b000: begin // IDLE
            if(!in) begin
                state_next = 3'b001; // START
                counter_next = 3'b000;
                data_next = 8'b0;
            end else begin
                state_next = 3'b000; // IDLE
                counter_next = 3'b000;
                data_next = 8'b0;
            end
        end
        3'b001: begin // START
            state_next = 3'b010; // DATA
            counter_next = 3'b001;
            data_next = {7'b0, in};
        end
        3'b010: begin // DATA
            if(counter_reg < 3'b100) begin
                state_next = 3'b010; // DATA
                counter_next = counter_reg + 1'b1;
                data_next = {data_reg[6:0], in};
            end else begin
                state_next = 3'b011; // STOP
                counter_next = 3'b000;
                data_next = data_reg;
            end
        end
        3'b011: begin // STOP
            if(in) begin
                state_next = 3'b000; // IDLE
                counter_next = 3'b000;
                data_next = 8'b0;
                done_reg = 1'b1;
                out_byte_reg = data_reg;
            end else begin
                state_next = 3'b011; // STOP
                counter_next = 3'b000;
                data_next = 8'b0;
                done_reg = 1'b0;
            end
        end
        default: begin
            state_next = 3'b000; // IDLE
            counter_next = 3'b000;
            data_next = 8'b0;
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state_reg <= 3'b000;
        counter_reg <= 3'b000;
        data_reg <= 8'b0;
        done_reg <= 1'b0;
    end else begin
        state_reg <= state_next;
        counter_reg <= counter_next;
        data_reg <= data_next;
        done_reg <= done_reg;
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule