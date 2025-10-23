module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// FSM states
enum logic [1:0] {IDLE, RECEIVE, ERROR} state, next_state;

// Data receiver signals
reg [7:0] data;
reg data_valid;

// FSM logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (~in) begin // Start bit detected
                    state <= RECEIVE;
                end
            end
            RECEIVE: begin
                if (data_valid) begin
                    if (in) begin // Stop bit correct
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin // Stop bit incorrect
                        state <= ERROR;
                    end
                end
            end
            ERROR: begin
                if (in) begin // Stop bit detected
                    state <= IDLE;
                end
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

// Data receiver module
module DataReceiver(
    input clk,
    input in,
    output reg [7:0] data,
    output reg data_valid
);

reg [2:0] bit_count;

always @(posedge clk) begin
    if (bit_count == 0) begin
        data <= 8'b0;
        data_valid <= 1'b0;
    end else if (bit_count < 8) begin
        data <= {data[6:0], in}; // Shift in new bit
        bit_count <= bit_count + 1;
    end else if (bit_count == 8) begin
        data <= {data[6:0], in}; // Load last bit
        data_valid <= 1'b1;
        bit_count <= 0;
    end
end

endmodule

DataReceiver data_receiver(
   .clk(clk),
   .in(in),
   .data(data),
   .data_valid(data_valid)
);

endmodule