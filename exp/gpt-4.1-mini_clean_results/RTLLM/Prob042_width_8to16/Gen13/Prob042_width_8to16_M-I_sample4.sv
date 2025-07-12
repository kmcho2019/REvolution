module width_8to16 (
    input          clk,
    input          rst_n,
    input          valid_in,
    input  [7:0]   data_in,
    output         valid_out,
    output [15:0]  data_out
);

    // State encoding
    localparam IDLE            = 1'b0;
    localparam WAIT_FOR_SECOND = 1'b1;

    reg         state, next_state;
    reg [7:0]   data_lock;
    reg         valid_out_reg;
    reg [15:0]  data_out_reg;

    // Next-state logic
    always @(*) begin
        next_state = state; // default hold state
        case (state)
            IDLE: begin
                if (valid_in)
                    next_state = WAIT_FOR_SECOND;
            end
            WAIT_FOR_SECOND: begin
                if (valid_in)
                    next_state = IDLE;
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= IDLE;
            data_lock     <= 8'd0;
            valid_out_reg <= 1'b0;
            data_out_reg  <= 16'd0;
        end else begin
            state <= next_state;

            // Default: clear valid_out_reg only if previously asserted
            if (valid_out_reg)
                valid_out_reg <= 1'b0;

            case (state)
                IDLE: begin
                    if (valid_in) begin
                        data_lock <= data_in; // store first byte
                    end
                end
                WAIT_FOR_SECOND: begin
                    if (valid_in) begin
                        data_out_reg  <= {data_lock, data_in};
                        valid_out_reg <= 1'b1; // assert valid output one cycle after second byte
                    end
                end
            endcase
        end
    end

    assign valid_out = valid_out_reg;
    assign data_out  = data_out_reg;

endmodule