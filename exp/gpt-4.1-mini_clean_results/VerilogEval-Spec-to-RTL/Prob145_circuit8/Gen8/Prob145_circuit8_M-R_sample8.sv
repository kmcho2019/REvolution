module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

    // Define states using parameters for clarity
    localparam IDLE  = 2'b00;
    localparam S1    = 2'b01;
    localparam S3    = 2'b11;
    localparam S2    = 2'b10;

    reg [1:0] state = IDLE;

    // State register update on positive clock edge
    always @(posedge clock) begin
        case(state)
            IDLE: state <= (a) ? S1 : IDLE;
            S1:   state <= (a) ? S3 : IDLE;
            S3:   state <= (a) ? S3 : S2;
            S2:   state <= (a) ? S3 : IDLE;
            default: state <= IDLE;
        endcase
    end

    // Output logic (Moore machine): outputs depend only on current state
    always @(*) begin
        case(state)
            IDLE: begin p = 0; q = 0; end
            S1:   begin p = 0; q = 0; end
            S3:   begin p = 1; q = 0; end
            S2:   begin p = 0; q = 1; end
            default: begin p = 0; q = 0; end
        endcase
    end

endmodule