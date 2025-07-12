module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // State definition parameters
    localparam NORMAL = 1'b0;
    localparam EMERGENCY = 1'b1;
    
    reg state;

    always @(*) begin
        // Default output values
        shut_off_computer = 1'b0;
        keep_driving = 1'b0;
        
        // State determination
        state = cpu_overheated ? EMERGENCY : NORMAL;
        
        // Output logic based on state and inputs
        case (state)
            NORMAL: begin
                if (~arrived) begin
                    keep_driving = ~gas_tank_empty;
                end
            end
            EMERGENCY: begin
                shut_off_computer = 1'b1;
                keep_driving = 1'b0;  // Safety feature: don't drive during emergency
            end
        endcase
    end

endmodule