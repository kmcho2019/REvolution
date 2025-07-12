module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

    reg [1:0] current_state;
    reg [1:0] next_state;

    // Define states
    parameter IDLE = 2'b00;
    parameter SEQ10 = 2'b01;
    parameter SEQ101 = 2'b10;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            IDLE: begin
                if (x) begin
                    next_state <= SEQ10;
                end else begin
                    next_state <= IDLE;
                end
            end
            SEQ10: begin
                if (x) begin
                    next_state <= SEQ101;
                end else begin
                    next_state <= SEQ10;
                end
            end
            SEQ101: begin
                if (x) begin
                    next_state <= SEQ101;
                end else begin
                    next_state <= SEQ10;
                end
            end
        endcase
    end

    always @(*) begin
        case (current_state)
            IDLE: z <= 1'b0;
            SEQ10: z <= 1'b0;
            SEQ101: z <= x;
        endcase
    end

endmodule