module accu(
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output          valid_out,
    output  [9:0]   data_out
);

reg [1:0] state;
reg [1:0] state_next;
reg [7:0] data_reg [3:0];
reg [2:0] count;
reg [2:0] count_next;
reg [9:0] sum;

always @(*) begin
    case(state)
        2'b00: begin // idle state
            if(valid_in) begin
                state_next = 2'b01;
                count_next = 1;
                data_reg[0] = data_in;
            end else begin
                state_next = 2'b00;
                count_next = 0;
            end
        end
        2'b01: begin // data accumulation state
            if(valid_in) begin
                if(count == 3) begin
                    state_next = 2'b10;
                    count_next = 0;
                    data_reg[count] = data_in;
                end else begin
                    state_next = 2'b01;
                    count_next = count + 1;
                    data_reg[count] = data_in;
                end
            end else begin
                state_next = 2'b01;
                count_next = count;
            end
        end
        2'b10: begin // output state
            state_next = 2'b00;
            count_next = 0;
        end
        default: begin
            state_next = 2'b00;
            count_next = 0;
        end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= 2'b00;
        count <= 0;
    end else begin
        state <= state_next;
        count <= count_next;
    end
end

always @(*) begin
    sum = data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
end

assign valid_out = (state == 2'b10) ? 1'b1 : 1'b0;
assign data_out = (state == 2'b10) ? sum : 10'b0;

endmodule