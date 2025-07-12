module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] state;
reg [1:0] counter;
reg [9:0] accumulated_sum;

always @(*) begin
    case(state)
        2'b00: begin // idle state
            if(valid_in) begin
                state = 2'b01;
                counter = 1;
                accumulated_sum = data_in;
            end else begin
                state = 2'b00;
                counter = 0;
                accumulated_sum = 0;
            end
        end
        2'b01: begin // accumulating state
            if(valid_in) begin
                counter = counter + 1;
                accumulated_sum = accumulated_sum + data_in;
                if(counter == 4) begin
                    state = 2'b00;
                    valid_out = 1;
                    data_out = accumulated_sum;
                end else begin
                    state = 2'b01;
                    valid_out = 0;
                end
            end else begin
                state = 2'b01;
                valid_out = 0;
            end
        end
        default: begin
            state = 2'b00;
            counter = 0;
            accumulated_sum = 0;
            valid_out = 0;
        end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        state <= 2'b00;
        valid_out <= 0;
        data_out <= 0;
    end else begin
        valid_out <= (state == 2'b01 && counter == 4)? 1 : 0;
    end
end

endmodule