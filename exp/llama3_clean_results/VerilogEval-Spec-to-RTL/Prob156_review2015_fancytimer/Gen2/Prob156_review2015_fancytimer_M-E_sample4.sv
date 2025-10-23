module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

// Microcode ROM
reg [3:0] microcode[0:7];

always @(posedge clk) begin
    if (reset) begin
        microcode[0] <= 4'b0000; // Idle state
        microcode[1] <= 4'b0001; // Pattern detection state
        microcode[2] <= 4'b0010; // Delay loading state
        microcode[3] <= 4'b0011; // Counting state
        microcode[4] <= 4'b0100; // Done state
        microcode[5] <= 4'b0101; // Acknowledgment state
        microcode[6] <= 4'b0110; // Reset state
        microcode[7] <= 4'b0111; // Idle state
    end
end

// State machine
reg [1:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Idle state
    end else begin
        case (state)
            2'b00: begin // Idle state
                if (data == 1'b1) begin
                    state <= 2'b01; // Pattern detection state
                end
            end
            2'b01: begin // Pattern detection state
                if (data == 1'b0) begin
                    state <= 2'b10; // Delay loading state
                end
            end
            2'b10: begin // Delay loading state
                if (data == 1'b1) begin
                    state <= 2'b11; // Counting state
                end
            end
            2'b11: begin // Counting state
                if (count == 4'b0000) begin
                    state <= 2'b10; // Done state
                end
            end
            2'b10: begin // Done state
                if (ack) begin
                    state <= 2'b00; // Acknowledgment state
                end
            end
        endcase
    end
end

// Timer module
reg [9:0] timer;

always @(posedge clk) begin
    if (reset) begin
        timer <= 10'b0;
    end else if (state == 2'b11) begin
        timer <= timer + 1'b1;
    end
end

// Counter module
reg [3:0] counter;

always @(posedge clk) begin
    if (reset) begin
        counter <= 4'b0;
    end else if (state == 2'b11) begin
        if (timer == 10'b1000000000) begin
            counter <= counter - 1'b1;
            timer <= 10'b0;
        end
    end
end

// Output assignments
assign count = counter;
assign counting = (state == 2'b11) ? 1'b1 : 1'b0;
assign done = (state == 2'b10) ? 1'b1 : 1'b0;

endmodule