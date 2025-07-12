module TopModule(
    input           clk,
    input           reset,
    input           data,
    input           done_counting,
    input           ack,
    output          shift_ena,
    output          counting,
    output          done
);

reg [1:0] state;
reg [3:0] pattern;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE
        pattern <= 4'b0000;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (pattern == 4'b1101) begin
                    state <= 2'b01; // SHIFT
                    pattern <= 4'b0000;
                end else begin
                    pattern <= {pattern[2:0], data};
                end
            end
            2'b01: begin // SHIFT
                pattern <= {pattern[2:0], data};
                if (pattern[3]) begin
                    state <= 2'b10; // COUNT
                end
            end
            2'b10: begin // COUNT
                if (done_counting) begin
                    state <= 2'b11; // DONE
                end
            end
            2'b11: begin // DONE
                if (ack) begin
                    state <= 2'b00; // IDLE
                end
            end
        endcase
    end
end

assign shift_ena = (state == 2'b01) | (state == 2'b01 && pattern < 4'b1000);
assign counting = (state == 2'b10);
assign done = (state == 2'b11);

endmodule