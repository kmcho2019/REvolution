module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    // One-hot encoded states
    localparam IDLE = 4'b0001;
    localparam BIT0 = 4'b0010;
    localparam BIT1 = 4'b0100;
    localparam BIT2 = 4'b1000;
    
    reg [3:0] current_state, next_state;
    reg [3:0] data_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            data_reg <= 4'b0;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            current_state <= next_state;
            
            // Capture new data when in IDLE state
            if (current_state == IDLE) begin
                data_reg <= d;
                valid_out <= 1'b1;
            end else begin
                valid_out <= 1'b0;
            end
            
            // Output the appropriate bit based on state
            case (current_state)
                IDLE: dout <= d[3];  // MSB when new data arrives
                BIT0: dout <= data_reg[2];
                BIT1: dout <= data_reg[1];
                BIT2: dout <= data_reg[0];
                default: dout <= 1'b0;
            endcase
        end
    end
    
    always @(*) begin
        case (current_state)
            IDLE: next_state = BIT0;
            BIT0: next_state = BIT1;
            BIT1: next_state = BIT2;
            BIT2: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule