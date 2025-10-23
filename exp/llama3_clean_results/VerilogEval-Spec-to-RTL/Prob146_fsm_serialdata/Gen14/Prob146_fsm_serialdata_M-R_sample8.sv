module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] bit_counter;
reg [7:0] data;
reg idle, start, data_state;

// Combinational Logic for State Transitions
always @(*) begin
    done = 0;
    out_byte = 8'b0;
    if (idle) begin
        if (!in) begin
            start = 1;
            idle = 0;
            data_state = 0;
            bit_counter = 0;
        end else begin
            start = 0;
            idle = 1;
            data_state = 0;
        end
    end else if (start) begin
        start = 0;
        data_state = 1;
    end else if (data_state) begin
        if (bit_counter == 7) begin
            if (in) begin // Correct stop bit
                idle = 1;
                data_state = 0;
                bit_counter = 0;
                out_byte = data;
                done = 1;
            end else begin // Incorrect stop bit, wait for stop bit
                data_state = 1;
                bit_counter = 0;
            end
        end else begin
            data_state = 1;
            bit_counter = bit_counter + 1;
        end
    end
end

// Sequential Logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        idle = 1;
        start = 0;
        data_state = 0;
        bit_counter = 0;
        data = 8'b0;
    end else if (data_state) begin
        data = {data[6:0], in};
    end else begin
        data = 8'b0;
    end
end

assign idle = ~start & ~data_state;

endmodule