module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // State encoding (one-hot)
    localparam [1:0] SAFE       = 2'b01;
    localparam [1:0] OVERHEATED = 2'b10;
    
    reg [1:0] state;

    always @(*) begin
        // Default outputs
        shut_off_computer = 1'b0;
        keep_driving = 1'b0;
        
        // State transitions
        if (cpu_overheated) begin
            state = OVERHEATED;
        end else begin
            state = SAFE;
        end
        
        // Output logic based on state
        case (state)
            OVERHEATED: begin
                shut_off_computer = 1'b1;
                // Vehicle control is don't-care when overheating
            end
            SAFE: begin
                keep_driving = ~arrived & ~gas_tank_empty;
            end
        endcase
    end

endmodule