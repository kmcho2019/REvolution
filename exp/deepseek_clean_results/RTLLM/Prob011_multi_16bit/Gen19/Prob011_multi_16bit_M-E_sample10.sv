module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // FSM states
    localparam IDLE = 0;
    localparam INIT = 1;
    localparam PP1  = 2;
    localparam PP2  = 3;
    localparam PP3  = 4;
    localparam PP4  = 5;
    localparam PP5  = 6;
    localparam PP6  = 7;
    localparam PP7  = 7;
    localparam DONE = 8;

    reg [3:0] state;
    reg [31:0] pp_acc;  // Partial product accumulator
    reg [15:0] multiplicand;
    reg [17:0] multiplier;  // Extended for Booth encoding
    
    // Booth encoding signals
    wire [8:0] pp_select;
    wire [31:0] pp [0:7];
    
    // Generate partial products
    assign pp[0] = multiplier[1:0] == 2'b01 ? {16'b0, multiplicand} :
                   multiplier[1:0] == 2'b10 ? {15'b0, ~multiplicand + 1, 1'b0} : 32'b0;
    
    assign pp[1] = multiplier[3:1] == 3'b001 ? {14'b0, multiplicand, 2'b0} :
                   multiplier[3:1] == 3'b010 ? {13'b0, ~multiplicand + 1, 3'b0} : 32'b0;
    
    assign pp[2] = multiplier[5:3] == 3'b001 ? {12'b0, multiplicand, 4'b0} :
                   multiplier[5:3] == 3'b010 ? {11'b0, ~multiplicand + 1, 5'b0} : 32'b0;
    
    assign pp[3] = multiplier[7:5] == 3'b001 ? {10'b0, multiplicand, 6'b0} :
                   multiplier[7:5] == 3'b010 ? {9'b0, ~multiplicand + 1, 7'b0} : 32'b0;
    
    assign pp[4] = multiplier[9:7] == 3'b001 ? {8'b0, multiplicand, 8'b0} :
                   multiplier[9:7] == 3'b010 ? {7'b0, ~multiplicand + 1, 9'b0} : 32'b0;
    
    assign pp[5] = multiplier[11:9] == 3'b001 ? {6'b0, multiplicand, 10'b0} :
                   multiplier[11:9] == 3'b010 ? {5'b0, ~multiplicand + 1, 11'b0} : 32'b0;
    
    assign pp[6] = multiplier[13:11] == 3'b001 ? {4'b0, multiplicand, 12'b0} :
                   multiplier[13:11] == 3'b010 ? {3'b0, ~multiplicand + 1, 13'b0} : 32'b0;
    
    assign pp[7] = multiplier[15:13] == 3'b001 ? {2'b0, multiplicand, 14'b0} :
                   multiplier[15:13] == 3'b010 ? {1'b0, ~multiplicand + 1, 15'b0} : 32'b0;

    // FSM control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            pp_acc <= 32'b0;
            done <= 1'b0;
            yout <= 32'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        multiplicand <= ain;
                        multiplier <= {bin, 2'b0};  // Pad for Booth
                        state <= INIT;
                    end
                end
                
                INIT: begin
                    pp_acc <= pp[0];
                    state <= PP1;
                end
                
                PP1: begin
                    pp_acc <= pp_acc + pp[1];
                    state <= PP2;
                end
                
                PP2: begin
                    pp_acc <= pp_acc + pp[2];
                    state <= PP3;
                end
                
                PP3: begin
                    pp_acc <= pp_acc + pp[3];
                    state <= PP4;
                end
                
                PP4: begin
                    pp_acc <= pp_acc + pp[4];
                    state <= PP5;
                end
                
                PP5: begin
                    pp_acc <= pp_acc + pp[5];
                    state <= PP6;
                end
                
                PP6: begin
                    pp_acc <= pp_acc + pp[6];
                    state <= PP7;
                end
                
                PP7: begin
                    pp_acc <= pp_acc + pp[7];
                    state <= DONE;
                end
                
                DONE: begin
                    yout <= pp_acc;
                    done <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule