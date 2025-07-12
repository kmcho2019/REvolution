module fsm(
    input  logic IN,
    input  logic CLK,
    input  logic RST,
    output logic MATCH
);

// Define states
localparam S0 = 4'd0; // Idle state
localparam S1 = 4'd1; // Seen first '1'
localparam S2 = 4'd2; // Seen '10'
localparam S3 = 4'd3; // Seen '100'
localparam S4 = 4'd4; // Seen '1001'
localparam S5 = 4'd5; // Seen '10011'

// Current state register
reg [3:0] currentState;

// Next state logic
always @(*) begin
    case (currentState)
        S0: begin
            if (RST) begin
                MATCH = 1'b0;
            end else if (IN) begin
                MATCH = 1'b0;
            end else begin
                MATCH = 1'b0;
            end
        end
        S1: begin
            if (RST) begin
                MATCH = 1'b0;
            end else if (!IN) begin
                MATCH = 1'b0;
            end else begin
                MATCH = 1'b0;
            end
        end
        S2: begin
            if (RST) begin
                MATCH = 1'b0;
            end else if (!IN) begin
                MATCH = 1'b0;
            end else begin
                MATCH = 1'b0;
            end
        end
        S3: begin
            if (RST) begin
                MATCH = 1'b0;
            end else if (IN) begin
                MATCH = 1'b0;
            end else begin
                MATCH = 1'b0;
            end
        end
        S4: begin
            if (RST) begin
                MATCH = 1'b0;
            end else if (IN) begin
                MATCH = 1'b0;
            end else begin
                MATCH = 1'b0;
            end
        end
        S5: begin
            if (RST) begin
                MATCH = 1'b0;
            end else if (IN) begin
                MATCH = 1'b1;
            end else begin
                MATCH = 1'b0;
            end
        end
        default: begin
            MATCH = 1'b0;
        end
    endcase
end

// State transition logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        currentState <= S0;
    end else begin
        case (currentState)
            S0: begin
                if (IN) begin
                    currentState <= S1;
                end else begin
                    currentState <= S0;
                end
            end
            S1: begin
                if (!IN) begin
                    currentState <= S2;
                end else begin
                    currentState <= S1;
                end
            end
            S2: begin
                if (!IN) begin
                    currentState <= S3;
                end else begin
                    currentState <= S1;
                end
            end
            S3: begin
                if (IN) begin
                    currentState <= S4;
                end else begin
                    currentState <= S1;
                end
            end
            S4: begin
                if (IN) begin
                    currentState <= S5;
                end else begin
                    currentState <= S1;
                end
            end
            S5: begin
                if (IN) begin
                    currentState <= S5;
                end else begin
                    currentState <= S1;
                end
            end
            default: begin
                currentState <= S0;
            end
        endcase
    end
end

endmodule