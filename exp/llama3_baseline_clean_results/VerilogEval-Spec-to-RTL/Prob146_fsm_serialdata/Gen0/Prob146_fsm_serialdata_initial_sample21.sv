module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;

reg [2:0] state_reg; // 3 states: IDLE, RECEIVE_DATA, VERIFY_STOP
localparam IDLE = 3'b001;
localparam RECEIVE_DATA = 3'b010;
localparam VERIFY_STOP = 3'b100;

reg [2:0] state_next;

reg [2:0] counter_reg; // counter for data bits
reg [2:0] counter_next;

always @(posedge clk) begin
    if (reset) begin
        state_reg <= IDLE;
        counter_reg <= 3'b000;
        out_byte_reg <= 8'b00000000;
        done_reg <= 1'b0;
    end else begin
        state_reg <= state_next;
        counter_reg <= counter_next;
        out_byte_reg <= out_byte_reg;
        done_reg <= done_reg;
        
        case (state_reg)
            IDLE: begin
                if (~in) begin // start bit detected
                    state_next <= RECEIVE_DATA;
                    counter_next <= 3'b000;
                    out_byte_reg <= 8'b00000000;
                end else begin
                    state_next <= IDLE;
                    counter_next <= 3'b000;
                end
            end
            
            RECEIVE_DATA: begin
                out_byte_reg <= {out_byte_reg[6:0], in}; // shift in the data bit
                counter_next <= counter_reg + 1'b1;
                
                if (counter_reg == 3'b111) begin // 8 data bits received
                    state_next <= VERIFY_STOP;
                end else begin
                    state_next <= RECEIVE_DATA;
                end
            end
            
            VERIFY_STOP: begin
                if (in) begin // stop bit detected
                    state_next <= IDLE;
                    counter_next <= 3'b000;
                    done_reg <= 1'b1;
                end else begin
                    state_next <= VERIFY_STOP;
                    counter_next <= 3'b000;
                    done_reg <= 1'b0;
                end
            end
            
            default: begin
                state_next <= IDLE;
                counter_next <= 3'b000;
                out_byte_reg <= 8'b00000000;
                done_reg <= 1'b0;
            end
        endcase
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule