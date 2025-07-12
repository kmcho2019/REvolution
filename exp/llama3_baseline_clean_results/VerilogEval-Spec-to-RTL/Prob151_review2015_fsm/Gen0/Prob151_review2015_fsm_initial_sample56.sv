module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

reg [1:0] state, next_state;
reg [3:0] pattern; // stores the input sequence
reg [3:0] count; // counts the number of bits shifted

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00;
        pattern <= 4'b0000;
        count <= 4'b0000;
    end else begin
        state <= next_state;
        pattern <= {pattern[2:0], data};
        if (state == 2'b01) begin
            count <= count + 1;
        end else begin
            count <= 4'b0000;
        end
    end
end

always @(*) begin
    case (state)
        2'b00: begin // IDLE state
            if (pattern == 4'b1101) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b01: begin // SHIFT state
            if (count == 4) begin
                next_state = 2'b10;
            end else begin
                next_state = 2'b01;
            end
        end
        2'b10: begin // COUNT state
            if (done_counting) begin
                next_state = 2'b11;
            end else begin
                next_state = 2'b10;
            end
        end
        2'b11: begin // DONE state
            if (ack) begin
                next_state = 2'b00;
            end else begin
                next_state = 2'b11;
            end
        end
    endcase
end

assign shift_ena = (state == 2'b01);
assign counting = (state == 2'b10);
assign done = (state == 2'b11);

endmodule