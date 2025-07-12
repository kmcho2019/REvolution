module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// Define the states
enum logic [1:0] {
    Idle,
    Start,
    Data,
    Stop
} state, next_state;

// Data byte storage
logic [7:0] data_byte;

// Counter for data bits
logic [2:0] data_count;

always_comb begin
    // Default values
    next_state = state;
    done = 0;

    case (state)
        Idle: begin
            if (!in) begin
                next_state = Start;
            end
        end
        Start: begin
            next_state = Data;
        end
        Data: begin
            if (data_count == 7) begin
                next_state = Stop;
            end
        end
        Stop: begin
            if (in) begin
                next_state = Idle;
                done = 1;
            end
        end
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        data_count <= 0;
        data_byte <= 0;
    end else begin
        state <= next_state;
        if (state == Start) begin
            data_count <= 0;
            data_byte <= 0;
        end else if (state == Data) begin
            data_byte[data_count] <= in;
            data_count <= data_count + 1;
        end
        if (done) begin
            out_byte <= {data_byte[6:0], in};
        end
    end
end

endmodule