module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [2:0] state; // One-hot encoded state variable
reg [2:0] next_state;
reg [7:0] shift_reg; // Shift register to hold the parallel output data
reg [2:0] cnt; // Counter to keep track of the number of bits received

// Define the states
localparam IDLE = 3'b001;
localparam RECEIVE_DATA = 3'b010;
localparam OUTPUT_VALID = 3'b100;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        shift_reg <= 8'b00000000;
        cnt <= 3'b000;
        dout_valid <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (din_valid) begin
                    state <= RECEIVE_DATA;
                    shift_reg <= {7'b0000000, din_serial};
                    cnt <= 3'b001;
                    dout_valid <= 1'b0;
                end
            end
            RECEIVE_DATA: begin
                if (din_valid) begin
                    shift_reg <= {shift_reg[6:0], din_serial};
                    cnt <= cnt + 1'b1;
                    if (cnt == 3'b1000) begin
                        state <= OUTPUT_VALID;
                    end
                end
            end
            OUTPUT_VALID: begin
                dout_valid <= 1'b1;
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

assign dout_parallel = shift_reg;

endmodule