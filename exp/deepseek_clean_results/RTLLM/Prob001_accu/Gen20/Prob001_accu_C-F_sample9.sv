module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // State definitions
    reg [1:0] state;  // 0=IDLE, 1=ACCUM_1, 2=ACCUM_2, 3=ACCUM_3
    reg [1:0] next_state;
    reg [9:0] next_data;
    reg next_valid_out;

    // Combinational logic for next state and outputs
    always_comb begin
        // Default assignments (hold current values)
        next_state = state;
        next_data = data_out;
        next_valid_out = 1'b0;

        if (valid_in) begin
            case (state)
                2'b00: begin  // IDLE
                    next_state = 2'b01;
                    next_data = data_in;
                end
                2'b01: begin  // ACCUM_1
                    next_state = 2'b10;
                    next_data = data_out + data_in;
                end
                2'b10: begin  // ACCUM_2
                    next_state = 2'b11;
                    next_data = data_out + data_in;
                end
                2'b11: begin  // ACCUM_3
                    next_state = 2'b00;
                    next_data = data_out + data_in;
                    next_valid_out = 1'b1;
                end
            endcase
        end
    end

    // Sequential logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b00;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end else begin
            state <= next_state;
            data_out <= next_data;
            valid_out <= next_valid_out;
        end
    end

endmodule