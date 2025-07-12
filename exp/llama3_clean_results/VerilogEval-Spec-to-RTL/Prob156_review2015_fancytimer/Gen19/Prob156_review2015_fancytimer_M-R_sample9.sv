module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [19:0] counter;
reg [3:0] delay;
reg [3:0] seq;
reg [3:0] delay_shift;
reg [4:0] state; // One-hot encoding

// Combinational logic
assign counting = state[3];
assign done = state[4];

// State machine
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 5'b00001; // IDLE
        delay <= 0;
        counter <= 0;
        seq <= 0;
        delay_shift <= 0;
        count <= 0;
    end else begin
        case (state)
            5'b00001: begin // IDLE
                if (data == 1'b1) begin
                    state <= 5'b00010; // SHIFT_PAT
                    seq <= {data, seq[2:0]};
                end
            end
            5'b00010: begin // SHIFT_PAT
                seq <= {data, seq[2:0]};
                if (seq == 4'b1101) begin
                    state <= 5'b00100; // SHIFT_DELAY
                    delay_shift <= data;
                end else if (data != 1'b1) begin
                    state <= 5'b00001; // IDLE
                end
            end
            5'b00100: begin // SHIFT_DELAY
                delay_shift <= {data, delay_shift[2:0]};
                if (delay_shift[0] == 1'b1) begin
                    state <= 5'b01000; // COUNT
                    delay <= delay_shift;
                    counter <= (delay + 1) * 1000 - 1;
                end
            end
            5'b01000: begin // COUNT
                if (counter > 0) begin
                    counter <= counter - 1;
                    if (counter % 1000 == 0) begin
                        delay <= delay - 1;
                    end
                    count <= delay;
                end else begin
                    state <= 5'b10000; // DONE
                end
            end
            5'b10000: begin // DONE
                if (ack == 1'b1) begin
                    state <= 5'b00001; // IDLE
                end
            end
        endcase
    end
end

endmodule