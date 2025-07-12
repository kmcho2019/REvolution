module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state;
reg [2:0] nextState;
reg [7:0] out_byte_reg;
reg done_reg;
reg [3:0] counter;

always @(*) begin
    case(state)
        3'b000: begin // IDLE state
            if(!in) begin
                nextState = 3'b001; // transition to START state
            end else begin
                nextState = 3'b000; // stay in IDLE state
            end
        end
        3'b001: begin // START state
            if(in) begin
                nextState = 3'b010; // transition to DATA state
                counter = 0;
            end else begin
                nextState = 3'b001; // stay in START state
            end
        end
        3'b010: begin // DATA state
            if(counter == 8) begin
                nextState = 3'b011; // transition to STOP state
            end else begin
                nextState = 3'b010; // stay in DATA state
            end
        end
        3'b011: begin // STOP state
            if(in) begin
                nextState = 3'b000; // transition to IDLE state
                done_reg = 1'b1;
            end else begin
                nextState = 3'b011; // stay in STOP state
            end
        end
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= 3'b000;
        out_byte_reg <= 8'b0;
        done_reg <= 1'b0;
        counter <= 4'b0;
    end else begin
        state <= nextState;
        if(state == 3'b010) begin
            out_byte_reg <= {out_byte_reg[6:0], in};
            counter <= counter + 1'b1;
        end
        if(nextState == 3'b000 && state == 3'b011) begin
            out_byte <= out_byte_reg;
            done <= done_reg;
            done_reg <= 1'b0;
        end
    end
end

endmodule