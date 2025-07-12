module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] delay;
reg [19:0] counter;
reg [1:0] state; // Binary encoding

// Combinational logic
assign counting = (state == 2'b10);
assign done = (state == 2'b11);

// State machine
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00; // IDLE
        delay <= 0;
        counter <= 0;
        count <= 0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (data == 1'b1) begin
                    state <= 2'b01; // SHIFT
                end
            end
            2'b01: begin // SHIFT
                if (data == 1'b0) begin
                    state <= 2'b00; // IDLE
                end else if (counter == 4'd4) begin
                    state <= 2'b10; // COUNT
                    counter <= (delay + 1) * 1000 - 1;
                end else begin
                    delay <= {data, delay[2:0]};
                    counter <= counter + 1;
                end
            end
            2'b10: begin // COUNT
                if (counter > 0) begin
                    counter <= counter - 1;
                    if (counter % 1000 == 0) begin
                        delay <= delay - 1;
                    end
                    count <= delay;
                end else begin
                    state <= 2'b11; // DONE
                end
            end
            2'b11: begin // DONE
                if (ack == 1'b1) begin
                    state <= 2'b00; // IDLE
                end
            end
        endcase
    end
end

endmodule