module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [2:0] state; // IDLE (3'b000), START (3'b001), DATA (3'b010), STOP (3'b011)
reg [7:0] byte; // data byte register
reg [2:0] bit_count; // counter for data bits

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // reset to IDLE state
        byte <= 8'b0;
        bit_count <= 3'b0;
        done <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // IDLE state
                if (!in) begin
                    state <= 3'b001; // transition to START state
                end else begin
                    state <= 3'b000; // stay in IDLE state
                end
            end
            3'b001: begin // START state
                state <= 3'b010; // transition to DATA state
                bit_count <= 3'b0;
            end
            3'b010: begin // DATA state
                byte[bit_count] <= in; // shift in data bit
                if (bit_count == 3'b111) begin
                    state <= 3'b011; // transition to STOP state
                end else begin
                    bit_count <= bit_count + 1'b1;
                end
            end
            3'b011: begin // STOP state
                if (in) begin
                    out_byte <= byte; // output data byte
                    done <= 1'b1; // assert done signal
                    state <= 3'b000; // transition back to IDLE state
                end else begin
                    state <= 3'b011; // stay in STOP state
                end
            end
            default: begin
                state <= 3'b000; // reset to IDLE state
            end
        endcase
    end
end

always @(posedge clk) begin
    if (reset || (state == 3'b000)) begin
        done <= 1'b0; // deassert done signal when in IDLE state or reset
    end
end

endmodule