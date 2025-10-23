module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

// FSM states
localparam IDLE   = 2'b00;
localparam STORE  = 2'b01;
localparam OUTPUT = 2'b10;

reg [1:0] state, next_state;
reg [7:0] first_byte;
reg [7:0] second_byte;

// Sequential state and registers update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state      <= IDLE;
        first_byte <= 8'd0;
        second_byte <= 8'd0;
        data_out   <= 16'd0;
        valid_out  <= 1'b0;
    end else begin
        state <= next_state;

        case (state)
            IDLE: begin
                valid_out <= 1'b0;
                if (valid_in) begin
                    first_byte <= data_in;
                end
            end
            STORE: begin
                valid_out <= 1'b0;
                if (valid_in) begin
                    second_byte <= data_in;
                end
            end
            OUTPUT: begin
                // Output registered one cycle after second valid_in
                data_out  <= {first_byte, second_byte};
                valid_out <= 1'b1;
            end
            default: begin
                valid_out <= 1'b0;
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (valid_in)
                next_state = STORE;
            else
                next_state = IDLE;
        end
        STORE: begin
            if (valid_in)
                next_state = OUTPUT;
            else
                next_state = STORE;
        end
        OUTPUT: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

endmodule